import { Controller } from "@hotwired/stimulus"
import { Chart, BarElement, BarController, CategoryScale, LinearScale, Tooltip } from "chart.js"

Chart.register(BarElement, BarController, CategoryScale, LinearScale, Tooltip)

const fmt = (v) =>
  Number(v).toLocaleString("ro-RO", { minimumFractionDigits: 2, maximumFractionDigits: 2 })

const yTick = (v) =>
  v >= 1000 ? (v / 1000).toLocaleString("ro-RO") + "k" : Number(v).toLocaleString("ro-RO")

export default class extends Controller {
  static values = { totalInvested: Number, totalRevenue: Number }

  connect() {
    this.chart = new Chart(this.element, {
      type: "bar",
      data: {
        labels: ["Paid", "Revenue"],
        datasets: [{
          data: [this.totalInvestedValue, this.totalRevenueValue],
          backgroundColor: ["#6366f1", "#10b981"],
          borderRadius: 8,
          borderSkipped: false,
          barPercentage: 0.6,
          categoryPercentage: 0.5,
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        layout: { padding: { top: 8 } },
        plugins: {
          legend: { display: false },
          tooltip: {
            padding: 10,
            callbacks: { label: (ctx) => " " + fmt(ctx.raw) }
          }
        },
        scales: {
          x: { grid: { display: false }, border: { display: false }, ticks: { font: { size: 12 } } },
          y: {
            grid: { color: "#f3f4f6" },
            border: { display: false },
            ticks: { maxTicksLimit: 4, font: { size: 11 }, callback: yTick }
          }
        }
      }
    })
  }

  disconnect() {
    this.chart?.destroy()
  }
}
